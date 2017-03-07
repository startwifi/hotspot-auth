class VisitorsController < ApplicationController
  before do
    save_params
    load_company
  end

  get '/' do
    return render_404 unless @company || @company&.active
    if @company.sms && (@company.sms.action.eql?('ident') || @company.sms.action.eql?('ident_auth'))
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
    return unless params[:me]
    session[:company_token] = params[:t]
    session[:link] = params[:l]
    session[:dst] = params[:d]
    session[:mac] = mac_address(params[:me])
  end
end
