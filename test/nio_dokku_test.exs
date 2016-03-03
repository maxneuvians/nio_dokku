defmodule NioDokkuTest do
  use ExUnit.Case, async: false
  import Mock

  test "dokku/1" do
    with_mock NioDokku, [dokku: fn(_ip) -> spawn(fn -> 1 + 2 end) end] do
      NioDokku.dokku("1.1.1.1")
      assert is_pid(NioDokku.dokku("1.1.1.1"))
      assert called NioDokku.dokku("1.1.1.1")
    end
  end

  test "dokku/2" do
    with_mock NioDokku, [dokku: fn(_pid, _command) -> "Result" end] do
      pid = spawn(fn -> 1 + 2 end)
      assert NioDokku.dokku(pid, "Test") == "Result"
      assert called NioDokku.dokku(pid, "Test")
    end
  end

  test "dokku/3" do
    with_mock NioDokku, [dokku: fn({_pid, _prev}, _command) -> "Result" end] do
      pid = spawn(fn -> 1 + 2 end)
      assert NioDokku.dokku({pid, "Prev"}, "Test") == "Result"
      assert called NioDokku.dokku({pid, "Prev"}, "Test")
    end
  end

  test "available_commands/1" do
    with_mock NioDokku, [available_commands: fn(_pid) -> ["help"] end] do
      pid = spawn(fn -> 1 + 2 end)
      assert NioDokku.available_commands(pid) == ["help"]
      assert called NioDokku.available_commands(pid)
    end
  end

end
