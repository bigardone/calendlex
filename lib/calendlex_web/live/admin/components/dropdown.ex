defmodule CalendlexWeb.Admin.Components.Dropdown do
  use Phoenix.Component

  alias Phoenix.LiveView.JS

  def show(assigns) do
    assigns = assign_new(assigns, :class, fn -> "" end)

    ~L"""
    <div
      class="<%= @class %>"
      id="<%= @id %>"
    >
      <div
        class="relative dropdown"
        phx-click-away="<%= JS.hide(to: "##{@id} .dropdown-content", transition: "hidden", time: 0) %>"
      >
        <div
          class="flex items-baseline cursor-pointer gap-x-1 dropdown-trigger"
          phx-click="<%= JS.toggle(to: "##{@id} .dropdown-content", in: "block", out: "hidden", time: 0) %>"
        >
          <%= render_slot(@trigger) %>
        </div>
        <div class="absolute right-0 z-20 flex flex-col hidden py-2 mt-2 overflow-hidden text-sm text-gray-800 bg-white border shadow-md rounded-md dropdown-content">
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    </div>
    """
  end
end
