# Adds operations missing from the standard adapter.
{
  title: "TSheets custom",

  connection: {
    fields: [
      {
        name: "subdomain",
        control_type: "subdomain",
        url: ".tsheets.com",
        label: "TSheets subdomain",
        hint: "Your TSheets sub domain name as found in your TSheets URL"
      },
      {
        name: "api_token",
        label: "API token",
      },
    ],

    authorization: {
      type: "custom_auth",

      credentials: lambda do
        headers("Authorization": "Bearer #{connection["api_token"]}")
      end
    }
  },

  test: lambda do
    true
  end,

  actions: {
    query_timesheets: {
      input_fields: lambda do
        [
          { name: "start_date", type: :timestamp },
          { name: "end_date", type: :timestamp },
        ]
      end,

      execute: lambda do |connection, input|
        {
          timesheets: get(
            "https://#{connection['subdomain']}.tsheets.com/api/v1/timesheets",
            start_date: input["start_date"].to_date.to_s,
            end_date: input["end_date"].to_date.to_s
          )["results"]["timesheets"].values
        }
      end,

      output_fields: lambda do
        [
          {
            name: "timesheets",
            type: "array",
            of: "object",
            properties: [
              { name: "id", type: "integer" },
              { name: "user_id", type: "integer" },
              { name: "jobcode_id", type: "integer" },
              { name: "start", type: "timestamp" },
              { name: "end", type: "timestamp" },
              { name: "duration", type: "integer" },
              { name: "date", type: "timestamp" },
              { name: "tz", type: "integer" },
              { name: "tz_str", type: "string" },
              { name: "type", type: "string" },
              { name: "location", type: "string" },
              { name: "on_the_clock", type: "boolean" },
              { name: "locked", type: "integer" },
              { name: "notes", type: "string" },
              {
                name: "customfields",
                type: "object",
                properties: [
                  # Add your custom fields here
                  # { name: "71138", label: "location" },
                ]
              }
            ]
          }
        ]
      end
    },
  },
}
