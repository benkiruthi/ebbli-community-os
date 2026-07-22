import { describe, expect, it } from "vitest";
import { toSlug } from "./slug";

describe("toSlug", () => {
  it("creates URL-safe community slugs", () => {
    expect(toSlug("Nairobi Creators & Builders")).toBe("nairobi-creators-builders");
  });

  it("trims repeated separators", () => {
    expect(toSlug("  Better   Together  ")).toBe("better-together");
  });
});
