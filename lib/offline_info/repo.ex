defmodule OfflineInfo.Repo do
  use Ecto.Repo,
    otp_app: :offline_info,
    adapter: Ecto.Adapters.Postgres
end
