# GitHub Actions Workflow Tasks

## Task 1: Trigger Configuration

Write the correct `on` trigger configuration to support Pull Requests and manual execution:

```yaml
name: PR Workflow

on:
    pull_request:
        branches:
            - master
    workflow_dispatch:
```

## Task 2: Job Dependency Design

Define two jobs where `test` depends on `build`:

```yaml
jobs:
    build:
        runs-on: ubuntu-latest
        steps:
            - uses: actions/checkout@v4
            - run: echo "Build step"

    test:
        runs-on: ubuntu-latest
        needs: build
        steps:
            - uses: actions/checkout@v4
            - run: echo "Test step"
```

## Task 3: Using GitHub Context Variables

Print branch name and commit ID:

```yaml
- name: Print context variables
    run: |
        echo "Branch: ${{ github.ref }}"
        echo "Commit ID: ${{ github.sha }}"
```

## Task 4: Pull Request Workflow

Complete workflow with PR trigger and dependent jobs:

```yaml
name: PR Workflow
on:
    pull_request:
        branches:
            - master

jobs:
    build:
        runs-on: ubuntu-latest
        steps:
            - uses: actions/checkout@v4
            - run: echo "Build step"

    test:
        runs-on: ubuntu-latest
        needs: build
        steps:
            - uses: actions/checkout@v4
            - run: echo "Test step"
```

## Task 5: Docker Build & Push

Build, tag, push, and remove Docker image:

```yaml
- name: Build Docker image
    run: docker build --build-arg ENV=dev -t ${{ env.REGISTRY }}/${{ env.REPOSITORY }}:${{ env.IMAGE_TAG }} .

- name: Push image
    run: docker push ${{ env.REGISTRY }}/${{ env.REPOSITORY }}:${{ env.IMAGE_TAG }}

- name: Remove local image
    run: docker rmi ${{ env.REGISTRY }}/${{ env.REPOSITORY }}:${{ env.IMAGE_TAG }}
```
