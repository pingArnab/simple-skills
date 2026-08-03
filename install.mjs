#!/usr/bin/env node

import { cpSync, existsSync, mkdirSync, rmSync } from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const validSkills = new Set(["all", "ask-first", "demo-first"]);
const validHarnesses = new Set(["auto", "agents", "codex", "claude", "copilot", "all"]);

function usage() {
  console.log("Usage: node install.mjs [--skill all|ask-first|demo-first] [--harness auto|agents|codex|claude|copilot|all] [--project PATH] [--target PATH] [--force]");
}

function parseArgs(argv) {
  const options = { skill: "all", harness: "auto", project: ".", target: "", force: false };
  for (let index = 0; index < argv.length; index += 1) {
    const argument = argv[index];
    if (argument === "--force") {
      options.force = true;
      continue;
    }
    if (argument === "--help" || argument === "-h") {
      usage();
      process.exit(0);
    }
    const key = argument.startsWith("--") ? argument.slice(2) : "";
    if (!["skill", "harness", "project", "target"].includes(key)) {
      throw new Error(`Unknown option: ${argument}`);
    }
    const value = argv[index + 1];
    if (!value || value.startsWith("--")) throw new Error(`${argument} requires a value`);
    options[key] = value;
    index += 1;
  }
  return options;
}

function getInstallRoots(options, projectPath) {
  if (options.target) {
    return [path.isAbsolute(options.target) ? path.resolve(options.target) : path.resolve(projectPath, options.target)];
  }

  const known = {
    agents: path.join(projectPath, ".agents", "skills"),
    codex: path.join(projectPath, ".agents", "skills"),
    claude: path.join(projectPath, ".claude", "skills"),
    copilot: path.join(projectPath, ".github", "skills"),
  };

  if (options.harness === "all") return [...new Set([known.agents, known.claude, known.copilot])];
  if (options.harness !== "auto") return [known[options.harness]];

  const detected = [];
  if (existsSync(path.join(projectPath, ".agents"))) detected.push(known.agents);
  if (existsSync(path.join(projectPath, ".claude"))) detected.push(known.claude);
  if (existsSync(path.join(projectPath, ".github", "skills"))) detected.push(known.copilot);
  return detected.length ? [...new Set(detected)] : [known.agents];
}

try {
  const options = parseArgs(process.argv.slice(2));
  if (!validSkills.has(options.skill)) throw new Error(`Invalid skill: ${options.skill}`);
  if (!validHarnesses.has(options.harness)) throw new Error(`Invalid harness: ${options.harness}`);

  const projectPath = path.resolve(options.project);
  if (!existsSync(projectPath)) throw new Error(`Project directory does not exist: ${projectPath}`);

  const repositoryPath = path.dirname(fileURLToPath(import.meta.url));
  const skillNames = options.skill === "all" ? ["ask-first", "demo-first"] : [options.skill];
  const installRoots = getInstallRoots(options, projectPath);

  for (const name of skillNames) {
    const source = path.join(repositoryPath, "skills", name, "SKILL.md");
    if (!existsSync(source)) throw new Error(`Packaged skill is missing: ${path.dirname(source)}`);
  }

  for (const root of installRoots) {
    for (const name of skillNames) {
      const destination = path.join(root, name);
      if (existsSync(destination) && !options.force) {
        throw new Error(`Skill already exists at '${destination}'. Re-run with --force to replace it.`);
      }
    }
  }

  for (const root of installRoots) {
    mkdirSync(root, { recursive: true });
    for (const name of skillNames) {
      const source = path.join(repositoryPath, "skills", name);
      const destination = path.join(root, name);
      if (existsSync(destination)) rmSync(destination, { recursive: true, force: true });
      cpSync(source, destination, { recursive: true });
      console.log(`Installed ${name} -> ${destination}`);
    }
  }
} catch (error) {
  console.error(error.message);
  usage();
  process.exit(1);
}
