# CI/CD Assignment - Day 1

## Task 1: Identify Problems Without CI/CD

### Scenario

A team deploys manually to production.

### Risks and Problems

1. **Human Errors and Inconsistency**
   - Manual deployments are prone to mistakes such as wrong file versions, missed configuration steps, and typos in deployment commands.
   - Different team members may deploy in different ways.

2. **No Repeatability**
   - Each deployment can be different because the process is not standardized.
   - What worked yesterday might not work today using the same steps.

3. **No Audit Trail**
   - Manual deployments do not create reliable logs for who deployed what, when, and what changed.
   - This makes debugging and rollback more difficult.

4. **Slow Release Cycle**
   - Manual testing, building, and deployment take a lot of time.
   - Developers spend more time deploying than building features.

5. **High Production Risk**
   - Without automated testing, bugs can reach production.
   - Rollback becomes harder if something breaks.

6. **Bottlenecks and Scalability Issues**
   - Only certain team members may be able to deploy.
   - This creates bottlenecks and does not scale well for frequent releases or multiple environments.

## Task 2: Explore GitHub Actions in a Repository

### What triggered the workflow?

The workflow is usually triggered by one of these events:

- `push` to the `main` or `master` branch
- `pull_request`
- `schedule`
- `workflow_dispatch` for manual runs

### What jobs are running?

Common jobs shown in GitHub Actions include:

- `build`
- `test`
- `lint`
- `deploy`

### What is the workflow trying to achieve?

Typical goals of the workflow are:

- Run tests on code changes
- Build Docker images or application artifacts
- Check code quality with linting
- Run security checks
- Deploy to production or a staging environment

## Task 3: Arrange the CI/CD Pipeline Flow

### Correct Order

1. Write code
2. Build Tests
3. Run tests
4. Deploy Application
5. Monitor Application

### Explanation

- **Write code**: The developer commits code changes.
- **Build Tests**: The application is compiled or built.
- **Run tests**: Unit tests and integration tests are executed to catch bugs.
- **Deploy Application**: The application is released to staging or production.
- **Monitor Application**: Performance, errors, logs, and user behavior are tracked.