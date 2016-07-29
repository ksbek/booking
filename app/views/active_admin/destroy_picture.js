$('.image-view#<%= @picture.id %>').fadeOut('quick', function(){ 
	this.remove();
    $('#user_profile_picture_attributes_id').remove();
});