# git-commit

Generate a Git commit message based on a scoped diff.

## Usage

`/git-commit [path]`

- `path`가 **파일 또는 폴더 경로**로 주어지면, **해당 경로(하위 포함)에서 발생한 변경 사항만** 기준으로 Commit Message를 생성해라.
- `path`가 비어있으면(= `$ARGUMENTS` 없음) 레포 전체 변경 사항을 기준으로 생성해라.

## Scope(중요)

- 스코프 경로:
  - `TARGET_PATH="$ARGUMENTS"`
  - `TARGET_PATH`가 비어있으면 `TARGET_PATH="."` 로 간주해라.
- **반드시** 아래 git diff/status 명령들에도 `-- "$TARGET_PATH"`를 붙여서, 스코프 밖 변경은 **절대** 분석/요약에 포함하지 마라.

다음 순서로 Git Commit Message를 생성해줘.

1. 스코프 내 변경 파일 목록을 먼저 확인
   - 우선순위: staged 변경(커밋 대상) → working tree 변경
   - 예:
     - `git diff --cached --name-status -- "$TARGET_PATH"`
     - (staged가 비어 있으면) `git diff --name-status -- "$TARGET_PATH"`
2. 스코프 내 변경 내용을 이전 Commit과 비교하여 확인
   - 우선순위: staged diff(커밋 대상) → working tree diff
   - 예:
     - `git diff --cached -- "$TARGET_PATH"`
     - (staged가 비어 있으면) `git diff -- "$TARGET_PATH"`
   - 필요 시 “이전 커밋(HEAD) 대비 작업 트리 변화” 확인:
     - `git diff HEAD -- "$TARGET_PATH"`
3. 스코프 내 변경 사항들에 대해 아래 포맷으로 Git Commit Message 생성
   - 스코프 밖 변경 사항이 존재하더라도(예: `git status`로 보임), **메시지에는 스코프 내 변경만** 반영해라.

### Git Commit Message 포맷

- <type>은 아래 Type can be 에 나오는 단어로 치환해라
- 포맷에 나오는 주의사항 및 기억해야할 사항들은 실제 Message에 남으면 안된다.
- ()에 나오는 내용들도 Message에 남으면 안된다.

```
<type>: (If applied, this commit will...) <subject> (Max 50 char)

|<----  Using a Maximum Of 50 Characters  ---->|

Explain why this change is being made
|<----   Try To Limit Each Line to a Maximum Of 72 Characters   ---->|

Provide links or keys to any relevant tickets, articles or other resources
Example: Github issue #23

--- COMMIT END ---
Type can be 
   feat     (new feature)
   fix      (bug fix)
   refactor (refactoring production code)
   style    (formatting, missing semi colons, etc; no code change)
   docs     (changes to documentation)
   test     (adding or refactoring tests; no production code change)
   chore    (updating grunt tasks etc; no production code change)
--------------------
Remember to
  - Capitalize the subject line
  - Use the imperative mood in the subject line
  - Do not end the subject line with a period
  - Separate subject from body with a blank line
  - Use the body to explain what and why vs. how
  - Can use multiple lines with "-" for bullet points in body
--------------------
```

### 주의 사항

- Git Commit Message는 한글로 작성
- 코드만으로는 표현이 안되는 의도, 상황 등을 Git Commit Message에 포함하기

This command will be available in chat with /git-commit
