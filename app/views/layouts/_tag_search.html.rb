<% if user_signed_in? %>
  <div class="search_form">
    <%= form_with url: tag_search_path, local: true,method: :get do |f| %>
      < %= f.text_field :word %>
      <%= f.submit "タグ検索" %>
    <% end %>
  </div>
<% end %>