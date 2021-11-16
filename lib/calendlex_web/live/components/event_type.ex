defmodule CalendlexWeb.Components.EventType do
  use Phoenix.Component

  def selector(assigns) do
    ~L"""
    <%= live_redirect to: @path do %>
      <div class="flex items-center p-6 pb-20 text-gray-400 bg-white border-t border-gray-300 cursor-pointer hover:bg-gray-200 gap-x-4">
        <div class="inline-block w-8 h-8 <%= @event_type.color %>-bg rounded-full border-2 border-white"></div>
        <h3 class="font-bold text-gray-900"><%= @event_type.name %></h3>
        <div class="ml-auto text-xl"><i class="fas fa-caret-right"></i></div>
      </div>
    <% end %>
    """
  end
end
