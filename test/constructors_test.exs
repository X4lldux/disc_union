defmodule DiscUnionTest.Constructors do
  use ExUnit.Case, async: true

  test "discriminated union can be constructed via `from/1` and `from!/1` from valid cases" do
    use ExampleDU
    use ExampleDUa

    asd_case = struct ExampleDU, %{case: Asd}
    rty_case = struct ExampleDU, %{case: {Rty, 1, :ok}}
    assert ExampleDU.from(Asd) == asd_case
    assert ExampleDU.from({Rty, 1, :ok}) == rty_case
    assert ExampleDU.from!(Asd) == asd_case
    assert ExampleDU.from!({Rty, 1, :ok}) == rty_case

    asd_case = struct ExampleDUa, %{case: :asd}
    rty_case = struct ExampleDUa, %{case: {:rty, 1, :ok}}
    assert ExampleDUa.from(:asd) == asd_case
    assert ExampleDUa.from({:rty, 1, :ok}) == rty_case
    assert ExampleDUa.from!(:asd) == asd_case
    assert ExampleDUa.from!({:rty, 1, :ok}) == rty_case
  end

  test "discriminated union can be constructed via `c/1` from valid cases" do
    use ExampleDU
    use ExampleDUa

    asd_case = struct ExampleDU, %{case: Asd}
    rty_case = struct ExampleDU, %{case: {Rty, 1, :ok}}
    assert ExampleDU.c(Asd) == asd_case
    assert ExampleDU.c(Rty, 1, :ok) == rty_case
    assert ExampleDU.c!(Asd) == asd_case
    assert ExampleDU.c!(Rty, 1, :ok) == rty_case

    asd_case = struct ExampleDUa, %{case: :asd}
    rty_case = struct ExampleDUa, %{case: {:rty, 1, :ok}}
    assert ExampleDUa.c(:asd) == asd_case
    assert ExampleDUa.c(:rty, 1, :ok) == rty_case
    assert ExampleDUa.c!(:asd) == asd_case
    assert ExampleDUa.c!(:rty, 1, :ok) == rty_case
  end

  test "discriminated union can be constructed via named constructors that construct at compile-time from valid cases" do
    use ExampleDU
    use ExampleDUa

    asd_case = struct ExampleDU, %{case: Asd}
    rty_case = struct ExampleDU, %{case: {Rty, 1, :ok}}
    assert ExampleDU.asd == asd_case
    assert ExampleDU.asd == ExampleDU.from(Asd)
    assert ExampleDU.asd == ExampleDU.from!(Asd)
    assert ExampleDU.rty(1, :ok) == rty_case
    assert ExampleDU.rty(1, :ok) == ExampleDU.from({Rty, 1, :ok})
    assert ExampleDU.rty(1, :ok) == ExampleDU.from!({Rty, 1, :ok})

    asd_case = struct ExampleDUa, %{case: :asd}
    rty_case = struct ExampleDUa, %{case: {:rty, 1, :ok}}
    assert ExampleDUa.asd == asd_case
    assert ExampleDUa.rty(1, :ok) == rty_case
    assert ExampleDUa.rty(1, :ok) == ExampleDUa.from({:rty, 1, :ok})
    assert ExampleDUa.rty(1, :ok) == ExampleDUa.from!({:rty, 1, :ok})
  end

  test "discriminated union's named constructors should not be created when `named_constructors` is false" do
    assert_raise UndefinedFunctionError, fn ->
      Code.eval_quoted(quote do
                        use ExampleDUdc
                        ExampleDUdc.a
      end)
    end
  end

  test "discriminated union's `from` constructor rises at compile-time for invalid cases" do
    assert_raise UndefinedUnionCaseError, "undefined union case: Qqq", fn ->
      Code.eval_quoted(quote do
                        use ExampleDU
                        ExampleDU.from Qqq
      end)
    end
    assert_raise UndefinedUnionCaseError, "undefined union case: Qqq in _", fn ->
      Code.eval_quoted(quote do
                        use ExampleDU
                        ExampleDU.from {Qqq, 123}
      end)
    end
    assert_raise UndefinedUnionCaseError, "undefined union case: :qqq", fn ->
      Code.eval_quoted(quote do
                        use ExampleDUa
                        ExampleDUa.from :qqq
      end)
    end
    assert_raise UndefinedUnionCaseError, "undefined union case: :qqq in _", fn ->
      Code.eval_quoted(quote do
                        use ExampleDUa
                        ExampleDUa.from {:qqq, 123}
      end)
    end
  end

  test "discriminated union's `from!` constructor rises at run-time for invalid cases" do
    assert_raise UndefinedUnionCaseError, fn ->
      use ExampleDU
      ExampleDU.from! Qqq
    end
    assert ExampleDU.from!(Qqq, :no_such_case) == :no_such_case

    assert_raise UndefinedUnionCaseError, fn ->
      use ExampleDUa
      ExampleDUa.from! :qqq
    end
    assert ExampleDUa.from!(:qqq, :no_such_case) == :no_such_case
  end

  test "discriminated union's `c` constructor rises at compile-time for invalid cases" do
    assert_raise UndefinedUnionCaseError, "undefined union case: Qqq", fn ->
      Code.eval_quoted(quote do
                        use ExampleDU
                        ExampleDU.c Qqq
      end)
    end
    assert_raise UndefinedUnionCaseError, "undefined union case: Qqq in _", fn ->
      Code.eval_quoted(quote do
                        use ExampleDU
                        ExampleDU.c Qqq, 123
      end)
    end
    assert_raise UndefinedUnionCaseError, "undefined union case: :qqq", fn ->
      Code.eval_quoted(quote do
                        use ExampleDUa
                        ExampleDUa.c :qqq
      end)
    end
    assert_raise UndefinedUnionCaseError, "undefined union case: :qqq in _", fn ->
      Code.eval_quoted(quote do
                        use ExampleDUa
                        ExampleDUa.c :qqq, 123
      end)
    end
  end

  test "discriminated union's `c!` constructor rises at compile-time for invalid cases" do
    assert_raise UndefinedUnionCaseError, "undefined union case: Qqq", fn ->
      Code.eval_quoted(quote do
                        use ExampleDU
                        ExampleDU.c! Qqq
      end)
    end
    assert_raise UndefinedUnionCaseError, "undefined union case: Qqq in _", fn ->
      Code.eval_quoted(quote do
                        use ExampleDU
                        ExampleDU.c! Qqq, 123
      end)
    end
    assert_raise UndefinedUnionCaseError, "undefined union case: :qqq", fn ->
      Code.eval_quoted(quote do
                        use ExampleDUa
                        ExampleDUa.c! :qqq
      end)
    end
    assert_raise UndefinedUnionCaseError, "undefined union case: :qqq in _", fn ->
      Code.eval_quoted(quote do
                        use ExampleDUa
                        ExampleDUa.c! :qqq, 123
      end)
    end
  end
end
