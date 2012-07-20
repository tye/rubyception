class Rubyception::Line
  attr_accessor :event
  attr_accessor :params
  attr_accessor :duration

  def initialize(event)
    self.event    = event.name
    self.params   = event.payload
    self.duration = event.duration.to_f.round(2)
  end

  def attrs
    hook,kind = event.split '.'
    hook      = hook.sub /\?/, ''
    data = {
      kind:     kind,
      hook:     hook,
      duration: duration }

    case "#{kind}_#{hook}".to_sym
      when :action_controller_write_fragment   then params
      when :action_controller_read_fragment    then params
      when :action_controller_expire_fragment  then params
      when :action_controller_exist_fragment   then params
      when :action_controller_write_page       then params
      when :action_controller_expire_page      then params
      when :action_controller_start_processing then params
      when :action_controller_process_action   then params
      when :action_controller_send_file        then params
      when :action_controller_send_data        then params
      when :action_controller_redirect_to      then params
      when :action_controller_halted_callback  then params
      when :action_view_render_template 
        params[:identifier] = remove_root params[:identifier]
      when :action_view_render_partial
        params[:identifier] = remove_root params[:identifier]
      when :active_record_sql                  then params
      when :active_record_identity             then params
      when :action_mailer_receive              then params
      when :action_mailer_deliver              then params
      when :active_resource_request            then params
      when :active_support_cache_read          then params
      when :active_support_cache_generate      then params
      when :active_support_cache_fetch_hit     then params
      when :active_support_cache_write         then params
      when :active_support_cache_delete        then params
      when :active_support_cache_exist         then params
    end
    data.merge! params
  end

  def remove_root text
    text.sub /#{Rails.root}/, ''
  end
end
