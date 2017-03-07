module WidgetsHelper
  def is_member?(social, group_id)
    case social
    when :facebook
      graph = Koala::Facebook::API.new(session[:user_token])
      graph.get_connections('me', "likes/#{group_id}").any?
    when :vkontakte
      group_params = {
        group_id: group_id,
        user_id: current_user.uid,
        access_token: session[:user_token]
      }
      query = RestClient.post('https://api.vk.com/method/groups.isMember', group_params)
      JSON.parse(query)['response'] == 1
    end
  end
end
