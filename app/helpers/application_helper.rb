# coding: utf-8

module ApplicationHelper
  
  def controller?(*controller)
     controller.include?(params[:controller])
   end

   def action?(*action)
     action.include?(params[:action])
   end
   
   def nav_link(link_text, link_path)
     class_name = current_page?(link_path) ? 'active' : ''
     link_to link_text, link_path, :class => class_name
   end
   
   def current_cart
     Cart.find(session[:cart_id])
   rescue ActiveRecord::RecordNotFound
     cart = Cart.create
     session[:cart_id] = cart.id
     cart
   end
   
   def appointment_link(event)
     if current_cart.events.exists?(event)
       link_to image_tag('heart.png'), event, method: :delete, :class => 'button-pink active'
     else
       link_to image_tag('heart.png'), line_items_path(event_id: event), :class => 'button-pink', :method => :post
     end
   end
   
   def order_link(event)
     if user_signed_in? && current_user.events.exists?(event)
       link_to "Я записан", cart_path(current_cart), :class => controller_name == "carts" ? 'appointment_link' : 'button-blue active'
     else
       link_to "Записаться", new_appointment_path(event_id: event), remote: true, :class => 'button-blue'
    end 
   end
   
   
   
   def cart_like(event)
       link_to "убрать из избранного", event, method: :delete, :class => controller_name == "carts" ? 'unlike_link' : 'button-blue active'
   end
   
   def cart_order(event)
     if user_signed_in? && current_user.events.exists?(event)
      "Я записался"
     else
       link_to "Записаться", new_appointment_path(event_id: event), remote: true, :class => 'appointment_link'
    end 
  end
  
  def event_checked(event)
    appointment = Appointment.find_by_user_id_and_event_id(current_user.id, event.id)
    if appointment && appointment.check?
      "Да"
    else
      "Нет"
    end
    
  end
   

   
   def resource_name
       :user
     end

   def resource
     @resource ||= User.new
   end

   def devise_mapping
     @devise_mapping ||= Devise.mappings[:user]
   end
   
   
end
