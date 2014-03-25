module ProjectsHelper
  def most_data_tracks
    current_most = 0
    @projects.each do |project|
      project.movement_groups.each do |group|
        if group.data_tracks.size > current_most
          current_most = group.data_tracks.size 
        end
      end
    end
    current_most
  end
  
  def mova_url
    #"http://www.sfu.ca/~oalemi/movan/"
    "http://142.58.181.193:8080/index.php"
  end
  
  def generate_mova_form
    form_tag(mova_url, :method=>"POST") do 
      @group.data_tracks.each do |track|
        unless track.asset.nil?
          hidden_field_tag :csvfile, URI.join(request.url, track.asset.file.url(:original, false))
				end
			end
		  submit_tag "Launch!"
    end # end form_tag
  end # end generate_mova_form
end
