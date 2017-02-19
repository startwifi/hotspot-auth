class VisitorsController < ApplicationController
  before do
    save_params
    load_company
  end

  get '/' do
    return render_404 unless @company || @company&.active
    if @company.sms.action.eql?('ident') || @company.sms.action.eql?('ident_auth')
      device = @company.devices.find_by_mac(session[:mac])
      return redirect to('/sms/authorize') unless device
      return unless @company.sms.action.eql?('ident') && @company.sms.adv
      haml :'widgets/sms/adv'
    end
    haml :'visitors/index'
  end

  private

  def load_company
    @company = Company.find_by_token(session[:company_token])
  end

  def save_params
    return unless params[:hs] && params[:hs][:mac_esc]
    session[:company_token] = params[:hs][:token]
    session[:link] = params[:hs][:link_login_only]
    session[:dst] = params[:hs][:dst]
    session[:mac] = mac_address(params[:hs][:mac_esc])
  end
end
