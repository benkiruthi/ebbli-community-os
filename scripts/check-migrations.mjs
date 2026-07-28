import { readdir } from "node:fs/promises";

const migrationDirectory = new URL("../supabase/migrations/", import.meta.url);
const migrationPattern = /^(\d{14})_[a-z0-9_]+\.sql$/;
const files = (await readdir(migrationDirectory)).filter((file) =>
  file.endsWith(".sql"),
);
const invalid = files.filter((file) => !migrationPattern.test(file));
const timestamps = files
  .map((file) => migrationPattern.exec(file)?.[1])
  .filter(Boolean);
const duplicates = [
  ...new Set(
    timestamps.filter((value, index) => timestamps.indexOf(value) !== index),
  ),
];

if (invalid.length || duplicates.length) {
  if (invalid.length)
    console.error(`Invalid migration names: ${invalid.join(", ")}`);
  if (duplicates.length)
    console.error(`Duplicate migration timestamps: ${duplicates.join(", ")}`);
  process.exitCode = 1;
} else {
  console.log(`Validated ${files.length} uniquely ordered migrations.`);
}
