defmodule NioDokku do

  @doc """
    Connects to a specific IP address using SSH. Returns the PID for the invoked
    connection or returns the atom descibing the error if there was an error
    connecting.
  """
  def dokku(ip) when is_binary(ip), do: connect(ip)

  @doc """
    Takes a PID and a string and runs the string as a command appended to
    dokku --force. Retuns a list of Strings
  """
  def dokku(pid, command) when is_pid(pid) do
    case SSHEx.cmd!(pid,
      "dokku --force " <> sanitize_input(command) |> String.to_char_list,
      [channel_timeout: 60000, exec_timeout: 60000]
    ) do
      {_, stderr} -> {pid, stderr |> clean_output}
      stdout -> {pid, stdout |> clean_output}
    end
  end

  @doc """
    Takes the PID and output from a previous dokku/2 call and chains the next
    command to it
  """
  def dokku({pid, _output}, command) when is_pid(pid) do
    dokku(pid, command)
  end

  @doc """
    Convenience function to not return the PID and just the output
  """
  def dokku!(pid, command) when is_pid(pid) do
    {_, output} = dokku(pid, command)
    output
  end

  @doc """
    Convenience function to not return the PID and just the output
  """
  def dokku!({pid, _output}, command) when is_pid(pid) do
    {_, output} = dokku(pid, command)
    output
  end

  @doc """
    Returns a list of all the commands available to the dokku command line.
  """
  def available_commands(pid) do
    {:ok, output, _} = SSHEx.run(pid, "dokku help" |> String.to_char_list)
    output
    |> String.split("\n")
    |> Enum.filter(fn line ->
      String.match?(line, ~r/\s{4}/)
    end)
    |> Enum.map(fn cmd ->
      cmd
      |> String.strip
      |> String.split(" ")
      |> Enum.at(0)
    end)
  end

  # Formats the SSH output
  defp clean_output(output) do
    output
    |> String.split("\n")
    |> Stream.map(&String.strip/1)
    |> Enum.filter(&(&1 != ""))
  end

  # Connects to passed IP using specified SSH private keys
  defp connect(ip) do
    case SSHEx.connect(
     ip: ip |> String.to_char_list,
     user: 'root',
     user_dir: Application.get_env(:nio_dokku, :ssh_key_path)
               |> String.to_char_list)
     do
       {:ok, conn} -> conn
       {:error, reason} -> reason
     end
  end

  # Sanitizes the input trying to avoid 'help; rm -rf /'
  defp sanitize_input(string) do
    String.replace(string, ~r/[^a-zA-Z0-9_\-:\/.\s=]/, "")
  end
end
