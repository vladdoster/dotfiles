#!/usr/bin/env zsh
# vim: set et:ft=zsh:sw=2:st=2:ts=2:tw=100:
# Unit tests for functions::format

# Test framework setup
setopt ERR_EXIT
setopt PIPE_FAIL

# Colors for output
autoload -U colors && colors

# Test counters
typeset -gi TESTS_RUN=0
typeset -gi TESTS_PASSED=0
typeset -gi TESTS_FAILED=0

# Test helper functions
assert_equals() {
    local expected="$1"
    local actual="$2"
    local test_name="$3"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if [[ "$expected" == "$actual" ]]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        print "${fg[green]}✓${reset_color} PASS: $test_name"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        print "${fg[red]}✗${reset_color} FAIL: $test_name"
        print "  Expected:"
        print "    $expected" | sed 's/^/    /'
        print "  Actual:"
        print "    $actual" | sed 's/^/    /'
        return 1
    fi
}

assert_contains() {
    local pattern="$1"
    local text="$2"
    local test_name="$3"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if [[ "$text" == *"$pattern"* ]]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        print "${fg[green]}✓${reset_color} PASS: $test_name"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        print "${fg[red]}✗${reset_color} FAIL: $test_name"
        print "  Pattern not found: $pattern"
        print "  In text:"
        print "$text" | sed 's/^/    /'
        return 1
    fi
}

# Setup test environment
export ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"
fpath=($ZDOTDIR/functions $fpath)
autoload -Uz functions::format

# Test 1: then keyword moved to end of line
test_then_formatting() {
    local test_func='test_then () {
    if [[ -n "$1" ]]
    then
        echo "test"
    fi
}'
    
    eval "$test_func"
    local output=$(functions::format test_then)
    
    assert_contains "if [[ -n \"\$1\" ]] then" "$output" "then moved to end of if statement"
}

# Test 2: do keyword moved to end of line
test_do_formatting() {
    local test_func='test_do () {
    for i in 1 2 3
    do
        echo $i
    done
}'
    
    eval "$test_func"
    local output=$(functions::format test_do)
    
    assert_contains "for i in 1 2 3 do" "$output" "do moved to end of for statement"
}

# Test 3: Case clause termination on new line
test_case_termination() {
    local test_func='test_case_term () {
    case "$1" in
        foo) echo "foo" ;;
    esac
}'
    
    eval "$test_func"
    local output=$(functions::format test_case_term)
    
    # Check that ;; is on its own line (preceded by whitespace - 12 spaces for 3 levels)
    assert_contains $'\n            ;;' "$output" "case terminator ;; on new line"
}

# Test 4: Case expressions on separate lines
test_case_expression_split() {
    local test_func='test_case_expr () {
    case "$1" in
        start) echo "Starting" ;;
        stop) echo "Stopping" ;;
    esac
}'
    
    eval "$test_func"
    local output=$(functions::format test_case_expr)
    
    # Pattern should be on its own line
    assert_contains $'(start)\n            echo "Starting"' "$output" "case pattern on separate line from command"
}

# Test 5: Complex nested structures
test_nested_structures() {
    local test_func='test_nested () {
    if [[ -n "$1" ]]
    then
        case "$1" in
            start)
                for i in 1 2
                do
                    echo $i
                done
                ;;
        esac
    fi
}'
    
    eval "$test_func"
    local output=$(functions::format test_nested)
    
    assert_contains "if [[ -n \"\$1\" ]] then" "$output" "nested: then keyword formatted"
    assert_contains "for i in 1 2 do" "$output" "nested: do keyword formatted"
    assert_contains $'\n                ;;' "$output" "nested: case terminator formatted"
}

# Test 6: Multiple case patterns
test_multiple_cases() {
    local test_func='test_multi_case () {
    case "$1" in
        a) echo "a" ;;
        b) echo "b" ;;
        c) echo "c" ;;
    esac
}'
    
    eval "$test_func"
    local output=$(functions::format test_multi_case)
    
    assert_contains "(a)" "$output" "multiple cases: pattern a formatted"
    assert_contains "(b)" "$output" "multiple cases: pattern b formatted"
    assert_contains "(c)" "$output" "multiple cases: pattern c formatted"
}

# Test 7: While loop formatting
test_while_loop() {
    local test_func='test_while () {
    while true
    do
        echo "loop"
        break
    done
}'
    
    eval "$test_func"
    local output=$(functions::format test_while)
    
    assert_contains "while true do" "$output" "while loop: do keyword formatted"
}

# Test 8: Function with no control structures (baseline)
test_simple_function() {
    local test_func='test_simple () {
    echo "hello"
    return 0
}'
    
    eval "$test_func"
    local output=$(functions::format test_simple)
    
    assert_contains 'echo "hello"' "$output" "simple function unchanged"
}

# Test 9: Empty case clause
test_empty_case() {
    local test_func='test_empty_case () {
    case "$1" in
        empty) ;;
    esac
}'
    
    eval "$test_func"
    local output=$(functions::format test_empty_case)
    
    assert_contains "(empty)" "$output" "empty case: pattern formatted"
    assert_contains ";;" "$output" "empty case: terminator present"
}

# Test 10: Long command formatting (requires sol - optional test)
test_long_command_formatting() {
    # Only run if sol is available
    if ! command -v sol >/dev/null 2>&1; then
        print "${fg[yellow]}○${reset_color} SKIP: long command test (sol not installed)"
        return 0
    fi
    
    local test_func='test_long_cmd () {
    echo "This is a very long command that definitely exceeds one hundred and twenty characters when combined" && echo "part2" && echo "part3"
}'
    
    eval "$test_func"
    local output=$(functions::format test_long_cmd)
    
    # Should contain line breaks for &&
    assert_contains $'&&\n' "$output" "long command broken at && operator"
}

# Run all tests
print "\n${fg[cyan]}Running functions::format unit tests...${reset_color}\n"

test_then_formatting
test_do_formatting
test_case_termination
test_case_expression_split
test_nested_structures
test_multiple_cases
test_while_loop
test_simple_function
test_empty_case
test_long_command_formatting

# Print summary
print "\n${fg[cyan]}Test Summary:${reset_color}"
print "  Total:  $TESTS_RUN"
print "  ${fg[green]}Passed:${reset_color} $TESTS_PASSED"
print "  ${fg[red]}Failed:${reset_color} $TESTS_FAILED"

if [[ $TESTS_FAILED -eq 0 ]]; then
    print "\n${fg[green]}All tests passed!${reset_color}\n"
    exit 0
else
    print "\n${fg[red]}Some tests failed!${reset_color}\n"
    exit 1
fi
