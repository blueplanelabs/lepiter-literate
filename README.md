# Lepiter Literate

Use Lepiter knowledge base for moldable literate programming.

In moldable (live) literate programming the source code is generated (tangled) from
design descriptions written in Lepiter pages: Pharo snippets create or modify the
classes and methods of the system. Lepiter Literate provides the tangle machinery
(`KnowledgeAssimilator`) plus provenance tracking that keeps the generated code and
its literate origin connected in both directions.

## Installation

```
Metacello new
	repository: 'github://blueplanelabs/lepiter-literate:main/src';
	baseline: 'LepiterLiterate';
	load
```

### Loading Lepiter-Literate knowledge base

```
BaselineOfLepiterLiterate loadKnowledgeBase
```

## Provenance: tracing tangled code back to its snippets

Every time the tangle evaluates a snippet, the system can record which classes and
methods that snippet created, modified or removed. The connection is not unique:
code created by one snippet may later be modified by snippets from other pages, so
each artifact keeps the **full ordered history** of the snippets that touched it.

The design is documented — and implemented, literately — in the page
*"Provenance: trazabilidad entre snippets y código generado"* of the knowledge base
shipped with this repository (linked from the *Knowledge* index page). Key decisions:

- **Capture by observation.** `KnowledgeAssimilator` wraps each snippet evaluation
  in `LeLiterateProvenance default capturingFor:during:`, which listens to
  `SystemAnnouncer` announcements (`ClassAdded`, `MethodModified`, …). Pages do not
  need to declare anything.
- **Single global registry.** `LeLiterateProvenance default` keeps a lateral
  registry keyed by artifact name (`'MyClass'`, `'MyClass>>#selector'`), so the
  history survives recompilation. Entries reference snippets by `LeUID` and resolve
  them lazily against the registered Lepiter databases. The registry is derivable:
  re-tangling the pages rebuilds it, and re-applying the same snippet is idempotent.
- **Explicit package filter.** Nothing is recorded until the client declares which
  packages it cares about:

  ```
  LeLiterateProvenance default addInterestingPackageNamed: 'MyProject-Core'
  ```

### Navigating in both directions

- Inspecting a generated class or method shows a **Literate origin** view: the
  ordered list of snippets that produced it (sequence, action, page, timestamp),
  each navigable to the live snippet.
- Inspecting a snippet shows a **Generated code** view: the artifacts it created or
  modified, each navigable to the class or method.

Programmatic queries are available on the registry, e.g.
`historyForClass:`, `historyForMethod:`, `entriesRelatedToClassNamed:` and
`entriesForSnippetUidString:`.
