defmodule Poc.Broadway do
  use Broadway

  alias Broadway.Message

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {BroadwaySQS.Producer,
          queue_url: System.get_env("AWS_SQL_URL"),
          config: [
            access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
            secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY")
          ]}
      ],
      processors: [
        default: [concurrency: 50]
      ],
      batchers: [
        s3: [concurrency: 5, batch_size: 10, batch_timeout: 1000]
      ]
    )
  end

  def handle_message(_processor_name, message, _context) do
    message
    |> Message.update_data(&process_data/1)
    |> Message.put_batcher(:s3)
    |> IO.inspect()

    IO.inspect(message)
  end

  def handle_batch(:s3, messages, _batch_info, _context) do
    # Send batch of messages to S3
  end

  defp process_data(data) do
    # Do some calculations, generate a JSON representation, process images.
  end
end
