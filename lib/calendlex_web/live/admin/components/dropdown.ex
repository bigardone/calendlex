defmodule CalendlexWeb.Admin.Components.Dropdown do
  use Phoenix.Component

  alias Phoenix.LiveView.JS

  def main(assigns) do
    ~H"""
    <div
      id={@id}
      class="relative dropdown"
      phx-click-away={click_away(@id)}>
      <div
        class="flex items-baseline cursor-pointer gap-x-1 dropdown-trigger"
        phx-click={trigger_click(@id)}>
        <%= render_slot(@trigger) %>
      </div>
      <div class="absolute right-0 z-20 flex flex-col hidden py-2 mt-2 overflow-hidden text-sm text-gray-800 bg-white border shadow-md rounded-md dropdown-content">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  defp click_away(id), do: JS.hide(to: content_selector(id), transition: "hidden", time: 0)

  defp trigger_click(id),
    do: JS.toggle(to: content_selector(id), in: "block", out: "hidden", time: 0)

  defp content_selector(id), do: "##{id} .dropdown-content"
end
