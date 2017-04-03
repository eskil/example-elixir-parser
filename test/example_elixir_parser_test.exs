defmodule ExampleElixirParserTest do
  use ExUnit.Case
  import ExampleElixirParser, only: [parse_and_eval: 1]
  doctest ExampleElixirParser

  test "assignment" do
    assert parse_and_eval(":a = 1") == %{a: 1}
  end

  test "add" do
    assert parse_and_eval(":a = 3 + 2") == %{a: 5}
  end

  test "sub" do
    assert parse_and_eval(":a = 3 - 2") == %{a: 1}
  end

  test "mul" do
    assert parse_and_eval(":a = 3 * 2") == %{a: 6}
  end

  test "div" do
    assert parse_and_eval(":a = 6 / 2") == %{a: 3}
  end

  test "operator precedence for mul" do
    assert parse_and_eval(":a = 3 * 2 + 1") == %{a: 7}
    assert parse_and_eval(":a = 3 * 2 - 1") == %{a: 5}
    assert parse_and_eval(":a = 1 + 3 * 2") == %{a: 7}
    assert parse_and_eval(":a = 1 - 3 * 2") == %{a: -5}
  end

  test "operator precedence for div" do
    assert parse_and_eval(":a = 6 / 2 + 1") == %{a: 4}
    assert parse_and_eval(":a = 6 / 2 - 1") == %{a: 2}
    assert parse_and_eval(":a = 1 + 6 / 2") == %{a: 4}
    assert parse_and_eval(":a = 1 - 6 / 2") == %{a: -2}
  end

  test "variable reference" do
    assert parse_and_eval("""
    :a = 3
    :b = 2
    :result = :a + :b
    """) == %{a: 3, b: 2, result: 5}
  end

  test "variable update" do
    assert parse_and_eval("""
    :a = 3
    :b = 2
    :a = :a + :b
    """) == %{a: 5, b: 2}
  end

  test "variables with numbers in name" do
    assert parse_and_eval("""
    :a1 = 3
    :a2 = 2
    :b1 = :a1 + :a2
    """) == %{a1: 3, a2: 2, b1: 5}
  end
end
