const modules = [
  "Authentication and profiles",
  "Communities and memberships",
  "Needs and opportunities",
  "Trust, moderation, and audit trails",
];

export default function HomePage() {
  return (
    <main>
      <section className="hero">
        <span className="eyebrow">Phase 2 technical foundation</span>
        <h1>Build trusted digital communities with an open foundation.</h1>
        <p>
          Ebbli Community OS is a mobile-first Next.js and Supabase reference
          implementation for communities that help people find people,
          opportunities, support, and pathways to progress.
        </p>
        <div className="actions">
          <a href="https://github.com/benkiruthi/ebbli-community-os">View repository</a>
          <a className="secondary" href="https://github.com/benkiruthi/ebbli-community-os/blob/main/CONTRIBUTING.md">
            Contribute
          </a>
        </div>
      </section>

      <section className="modules" aria-labelledby="modules-heading">
        <h2 id="modules-heading">Foundation modules</h2>
        <div className="grid">
          {modules.map((module) => (
            <article key={module}>
              <h3>{module}</h3>
              <p>Designed as reusable infrastructure with secure defaults and clear extension points.</p>
            </article>
          ))}
        </div>
      </section>
    </main>
  );
}
