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
end
