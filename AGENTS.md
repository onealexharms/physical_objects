# AGENTS.md

## Development Environment

- The top-level directory contains a `flake.nix` with a dev shell environment.
- You can assume the `claude` command was run within the dev shell environment.

## Source Code

- Clojure code, used to generate OpenSCAD code, is in `src`.
- `src/c3po` is general geometric and modeling utilities.
- `c3po.core` provides primitives for building geometry.
- `c3po.openscad` provides OpenSCAD-specific generation and utilities.
- Other `c3po` sub-namespaces provide common things like screws, linear rails, stepper motors.

## Design

- Physical objects are represented by maps with namespaced, semantic keys.
- Derived and computed data is done by plain functions in the same namespace.
- Some functions build 3d models for these things, using the `c3po.core` utilities to
  translate the higher-level things into geometric primitives.  These have the
  suffix `-model`.
- `src/cnc` and other peer directories have specific physical objects that aren't "common".
