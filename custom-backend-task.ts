import { spawn } from "cross-spawn";
import * as child_process from "child_process";
import * as fs from "fs";
import * as shiki from "shiki";

export async function highlight(fromElm: {
  body: string;
  language: string | null;
}) {
  const highlighter = await shiki.getHighlighter({
    theme: JSON.parse(await fs.promises.readFile("./Panda.json", "utf-8")),
  });
  return {
    tokens: highlighter.codeToThemedTokens(
      fromElm.body,
      fromElm.language || undefined,
      highlighter.getTheme(),
      {
        includeExplanation: false,
      }
    ),
    bg: highlighter.getTheme().bg,
    fg: highlighter.getTheme().fg,
  };
}

export async function gitTimestamps(filePath: string) {
  return await spawnCommand("git", [
    "--no-pager",
    "log",
    "--format=%ct",
    "--follow",
    filePath,
  ]);
}

export async function now() {
  return Date.now();
}

export async function environmentVariable(name: string) {
  const result = process.env[name];
  if (result) {
    return result;
  } else {
    throw `No environment variable called ${name}`;
  }
}

function spawnCommand(cmd: string, args: string[]): Promise<string> {
  return new Promise(function (resolve, reject) {
    const child = spawn(cmd, args);
    let output = "";
    child.stdout!.on("data", function (data: Buffer) {
      output += data;
    });
    child.on("close", function (code: number) {
      if (code !== 0) {
        reject(output);
      } else {
        resolve(output);
      }
    });
  });
}
