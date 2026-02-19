# Update Documentation

Sync documentation from source-of-truth (language-agnostic).

## Step 1: Detect Project Type

Automatically detect the project type by checking for these files:

| File | Project Type | Build Tool |
|------|-------------|-----------|
| `package.json` | Node.js/TypeScript | npm/yarn/pnpm |
| `pyproject.toml` | Python | poetry |
| `setup.py` | Python | pip/setuptools |
| `requirements.txt` | Python | pip |
| `pom.xml` | Java | Maven |
| `build.gradle` / `build.gradle.kts` | Java/Kotlin | Gradle |
| `Cargo.toml` | Rust | Cargo |
| `go.mod` | Go | Go modules |
| `Makefile` | Go/C/C++ | Make |
| `composer.json` | PHP | Composer |
| `Gemfile` | Ruby | Bundler |
| `.csproj` / `.sln` | C#/.NET | dotnet |

**Priority order** (if multiple files exist):
1. Primary build file (package.json, pyproject.toml, pom.xml, etc.)
2. Makefile (secondary, for additional commands)

## Step 2: Read Scripts/Commands

Extract available commands based on detected project type:

### Node.js/TypeScript (package.json)
```json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "test": "jest --coverage",
    "lint": "eslint . --fix"
  }
}
```
**Output**: `npm run dev`, `npm run build`, etc.

### Python (pyproject.toml)
```toml
[tool.poetry.scripts]
dev = "uvicorn app.main:app --reload"
test = "pytest --cov=app"
lint = "ruff check ."
```
**Output**: `poetry run dev`, `poetry run test`, etc.

### Java Maven (pom.xml)
Common Maven goals (standard lifecycle):
- `mvn clean` - Clean build artifacts
- `mvn compile` - Compile source code
- `mvn test` - Run tests
- `mvn package` - Create JAR/WAR
- `mvn install` - Install to local repository
- `mvn spring-boot:run` - Run Spring Boot app (if plugin present)

### Java Gradle (build.gradle)
```gradle
tasks.register('dev') {
    dependsOn 'bootRun'
}
```
**Output**: `./gradlew dev`, `./gradlew test`, etc.

### Rust (Cargo.toml)
Common Cargo commands (standard):
- `cargo run` - Run in debug mode
- `cargo build` - Build debug binary
- `cargo build --release` - Build optimized binary
- `cargo test` - Run tests
- `cargo clippy` - Run linter
- `cargo fmt` - Format code

### Go (Makefile or go.mod)
<!-- markdownlint-disable MD010 -->
```makefile
.PHONY: dev test build

dev:
	go run cmd/server/main.go

test:
	go test ./... -cover
```
<!-- markdownlint-enable MD010 -->
**Output**: `make dev`, `make test`, etc.

If no Makefile, use standard Go commands:
- `go run .` - Run application
- `go build` - Build binary
- `go test ./...` - Run tests

### PHP (composer.json)
```json
{
  "scripts": {
    "dev": "php artisan serve",
    "test": "phpunit"
  }
}
```
**Output**: `composer run dev`, `composer test`, etc.

### Ruby (Gemfile + Rakefile)
```ruby
# Rakefile
task :dev do
  exec 'rails server'
end
```
**Output**: `bundle exec rake dev`, etc.

### C#/.NET (.csproj)
Common dotnet commands (standard):
- `dotnet run` - Run application
- `dotnet build` - Build project
- `dotnet test` - Run tests
- `dotnet publish` - Publish for deployment

## Step 3: Read Environment Configuration

Extract environment variables from configuration files:

### Universal: .env.example
```bash
DATABASE_URL=postgresql://localhost:5432/mydb
REDIS_URL=redis://localhost:6379
API_KEY=your_api_key_here
```

### Java: application.properties / application.yml
```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/mydb
spring.redis.host=localhost
server.port=8080
```

### C#: appsettings.json
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=mydb"
  },
  "Redis": {
    "Host": "localhost"
  }
}
```

### Python: .env + config.py (often reads from .env)
### Go: .env (commonly used with godotenv)
### Rust: .env (commonly used with dotenvy)

## Step 4: Generate docs/CONTRIB.md

Create language-specific contribution guide:

```markdown
# Contributing Guide

## Project Information
- **Language**: [Detected language]
- **Build Tool**: [Detected build tool]
- **Package Manager**: [Detected package manager]

## Prerequisites
[Language-specific prerequisites, e.g., Node 18+, Python 3.11+, Java 17+]

## Setup

1. Clone the repository
2. Install dependencies:
   [Language-specific command, e.g., npm install, poetry install, mvn install]
3. Copy environment configuration:
   ```bash
   cp .env.example .env
   ```
4. Configure environment variables (see below)

## Available Commands

| Command | Description |
|---------|-------------|
| (auto-generated from Step 2) | (replace this placeholder) |

## Environment Variables

| Variable | Purpose | Format | Required |
|----------|---------|--------|----------|
| (auto-generated from Step 3) |  |  |  |

## Development Workflow

1. Start development server: [language-specific dev command]
2. Make your changes
3. Run linter: [language-specific lint command]
4. Run tests: [language-specific test command]
5. Build for production: [language-specific build command]

## Testing

- **Unit Tests**: [command]
- **Integration Tests**: [command if different]
- **Coverage**: [coverage command]
- **Minimum Coverage**: 80%

## Code Style

[Language-specific style guide reference]
- Node.js: ESLint + Prettier
- Python: Ruff + Black
- Java: Checkstyle + Google Java Format
- Rust: rustfmt + clippy
- Go: gofmt + golangci-lint
```

## Step 5: Generate docs/RUNBOOK.md

Create operational runbook:

```markdown
# Operational Runbook

## Deployment

### Prerequisites
- [Cloud platform, e.g., AWS, GCP, Azure, Vercel]
- [Access requirements]

### Build for Production
```bash
[Language-specific production build command]
```

### Deploy
[Deployment steps - can be enhanced with CI/CD config detection]

## Monitoring

### Health Checks
- Application: [health endpoint if detected]
- Database: [connection check]
- Cache: [redis/memcached check]

### Logs
[Language-specific logging conventions]

## Common Issues

### Issue: Build Fails
**Symptoms**: [build command] fails
**Solution**:
1. Clear build cache: [language-specific cache clear]
2. Reinstall dependencies: [language-specific reinstall]
3. Check [language version]

### Issue: Tests Fail
**Solution**:
1. Run single test: [language-specific single test command]
2. Check environment variables
3. Reset test database

### Issue: Slow Performance
**Solution**:
1. Check database query performance
2. Review cache hit rate
3. Profile application: [language-specific profiling tool]

## Rollback Procedures

1. Identify last good version: `git log --oneline -10`
2. Revert to previous version: `git revert <commit>` or redeploy previous tag
3. Verify health checks pass
4. Monitor error rates
```

## Step 6: Identify Obsolete Documentation

Find documentation files not modified in 90+ days:

```bash
find docs -name "*.md" -mtime +90 -type f
```

**Report format**:
```
⚠️ Obsolete Documentation Found:

These docs haven't been updated in 90+ days:
- docs/old-guide.md (Last modified: 150 days ago)
- docs/deprecated-api.md (Last modified: 200 days ago)

Action required: Review and update or remove these files.
```

## Step 7: Show Diff Summary

Compare current documentation with newly generated:

```
DOCUMENTATION UPDATE SUMMARY
============================

Files to be created:
  + docs/CONTRIB.md

Files to be updated:
  ~ docs/RUNBOOK.md (12 lines changed)

Obsolete files found:
  ! docs/old-setup-2023.md (180 days old)
  ! docs/legacy-deployment.md (250 days old)

Environment variables documented: 8
Commands documented: 12
Project type: Python (Poetry)

Would you like to proceed with these changes? (yes/no)
```

## Language-Specific Notes

### Python
- 가상환경 설정 추가: `python -m venv venv`, `source venv/bin/activate`
- pip vs poetry vs conda 감지 및 적절한 명령어 사용

### Java
- JDK 버전 명시 (pom.xml 또는 build.gradle에서 추출)
- Maven wrapper (`mvnw`) vs Gradle wrapper (`gradlew`) 감지

### Go
- Go version 명시 (go.mod에서 추출)
- Makefile 있으면 우선 사용, 없으면 표준 go 명령어 사용

### Rust
- Rust edition 명시 (Cargo.toml에서 추출)
- Features 문서화 (Cargo.toml [features] 섹션)

### Node.js
- Node version 명시 (package.json engines 필드)
- npm vs yarn vs pnpm 감지 (lock 파일 존재 여부)

## Single Source of Truth (Multi-Language)

| Language | Build Config | Env Config | Commands Source |
|----------|-------------|------------|-----------------|
| Node.js | package.json | .env.example | package.json scripts |
| Python | pyproject.toml / setup.py | .env.example | [tool.poetry.scripts] |
| Java | pom.xml / build.gradle | application.properties | Maven/Gradle lifecycle |
| Rust | Cargo.toml | .env.example | Cargo standard commands |
| Go | go.mod + Makefile | .env.example | Makefile targets |
| PHP | composer.json | .env.example | composer.json scripts |
| Ruby | Gemfile + Rakefile | .env.example | Rakefile tasks |
| C# | .csproj | appsettings.json | dotnet CLI |

코드가 곧 문서의 원본(Single Source of Truth)
