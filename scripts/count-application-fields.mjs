import { readFile } from "node:fs/promises";

const file = new URL(
  "../docs/CODEX_FOR_OSS_APPLICATION_DRAFT.md",
  import.meta.url,
);
const content = await readFile(file, "utf8");
const fieldPattern =
  /\*\*(Primary|Alternative [AB]) — (\d+) characters\*\*\n\n([^\n]+(?:\n[^\n]+)*)/g;

let failed = false;
for (const match of content.matchAll(fieldPattern)) {
  const [, label, declared, paragraph] = match;
  const actual = paragraph.replaceAll("\n", " ").length;
  const valid = actual === Number(declared) && actual <= 500;
  console.log(
    `${label}: ${actual}/500${valid ? "" : ` (declared ${declared})`}`,
  );
  failed ||= !valid;
}

if (failed) process.exitCode = 1;
