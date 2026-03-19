// SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
// SPDX-License-Identifier: Apache-2.0

const { execSync, spawnSync } = require("child_process");
const path = require("path");
const fs = require("fs");
const os = require("os");

const ROOT = path.resolve(__dirname, "..", "..");
const SCRIPTS = path.join(ROOT, "scripts");

// Detect bash executable on Windows
let bashExe = "bash";
if (os.platform() === "win32") {
  const commonBashPaths = [
    "C:\\Program Files\\Git\\bin\\bash.exe",
    "C:\\Program Files\\Git\\usr\\bin\\bash.exe",
    path.join(process.env.USERPROFILE || "", "AppData\\Local\\Programs\\Git\\bin\\bash.exe"),
  ];
  for (const p of commonBashPaths) {
    if (fs.existsSync(p)) {
      bashExe = p;
      break;
    }
  }
}

// Auto-detect Colima Docker socket (legacy ~/.colima or XDG ~/.config/colima)
if (!process.env.DOCKER_HOST) {
  const home = process.env.HOME || process.env.USERPROFILE || "/tmp";
  const candidates = [
    path.join(home, ".colima/default/docker.sock"),
    path.join(home, ".config/colima/default/docker.sock"),
  ];
  for (const sock of candidates) {
    if (fs.existsSync(sock)) {
      process.env.DOCKER_HOST = `unix://${sock}`;
      break;
    }
  }
}

function run(cmd, opts = {}) {
  const result = spawnSync(bashExe, ["-c", cmd], {
    stdio: "inherit",
    cwd: ROOT,
    env: { ...process.env, ...opts.env },
    ...opts,
  });
  if (result.status !== 0 && !opts.ignoreError) {
    console.error(`  Command failed (exit ${result.status}): ${cmd.slice(0, 80)}`);
    process.exit(result.status || 1);
  }
  return result;
}

function runCapture(cmd, opts = {}) {
  try {
    // On Windows, execSync uses cmd.exe, but we want bash -c for consistency
    const fullCmd = os.platform() === "win32" ? `"${bashExe}" -c "${cmd.replace(/"/g, '\\"')}"` : cmd;
    return execSync(fullCmd, {
      encoding: "utf-8",
      cwd: ROOT,
      env: { ...process.env, ...opts.env },
      stdio: ["pipe", "pipe", "pipe"],
      ...opts,
    }).trim();
  } catch (err) {
    if (opts.ignoreError) return "";
    throw err;
  }
}

module.exports = { ROOT, SCRIPTS, run, runCapture };
