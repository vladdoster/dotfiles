# Unit Tests for functions::format

This directory contains unit tests for the `functions::format` zsh function.

## Running Tests

### Using Make

```bash
make test-functions
```

### Directly with zsh

```bash
ZDOTDIR=$PWD/zsh/.config/zsh zsh zsh/.config/zsh/functions/functions::format.test.zsh
```

## Test Coverage

The test suite verifies the following functionality:

1. **then keyword formatting** - Verifies `then` is moved to end of if statements
2. **do keyword formatting** - Verifies `do` is moved to end of loop statements  
3. **Case termination** - Verifies `;;` is moved to new line with proper indentation
4. **Case expression splitting** - Verifies case patterns are on separate lines from commands
5. **Nested structures** - Verifies formatting works correctly with nested control structures
6. **Multiple case patterns** - Verifies multiple case branches are all formatted correctly
7. **While loops** - Verifies while loops are formatted correctly
8. **Simple functions** - Verifies simple functions without control structures remain unchanged
9. **Empty case clauses** - Verifies empty case clauses are handled correctly
10. **Long command formatting** - Verifies commands >120 chars are formatted with sol (if available)

## Test Output

Tests use colored output:
- ✓ Green checkmark = PASS
- ✗ Red X = FAIL  
- ○ Yellow circle = SKIP (for optional tests like sol integration)

## Dependencies

- **Required**: zsh
- **Optional**: sol (for long command formatting tests)

## Adding New Tests

To add a new test:

1. Create a new test function following the naming pattern `test_*`
2. Define a test function using heredoc or string literal
3. Evaluate the function with `eval`
4. Call `functions::format` on the function
5. Use `assert_equals` or `assert_contains` to verify expected output
6. Add the test function call to the end of the file

Example:

```zsh
test_my_new_feature() {
    local test_func='my_test () {
    # test code here
}'
    
    eval "$test_func"
    local output=$(functions::format my_test)
    
    assert_contains "expected pattern" "$output" "description of what is tested"
}
```
