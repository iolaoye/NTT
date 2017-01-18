CropSchedule.delete_all
CropSchedule.create!({:id => 1, :name =>'Corn', :state_id => 0, :class_id => 0, :status => 1}, :without_protection => true)
CropSchedule.create!({:id => 2, :name =>'Soybean', :state_id => 0, :class_id => 0, :status => 1}, :without_protection => true)
CropSchedule.create!({:id => 3, :name =>'Barley Cover Crop', :state_id => 0, :class_id => 2, :status => 1}, :without_protection => true)
CropSchedule.create!({:id => 4, :name =>'Winter Wheat Cover Crop', :state_id => 0, :class_id => 2, :status => 1}, :without_protection => true)

Schedule.delete_all
Schedule.create!({:id => 1, :event_order => 1, :month => 4, :day => 15, :year => 1, :activity_id => 2, :apex_operation => 580, :apex_crop => 2, :apex_fertilizer => 1, :apex_opv1 => 180, :apex_opv2 => 0, :crop_schedule_id => 1}, :without_protection => true)
Schedule.create!({:id => 2, :event_order => 2, :month => 4, :day => 15, :year => 1, :activity_id => 2, :apex_operation => 580, :apex_crop => 2, :apex_fertilizer => 2, :apex_opv1 => 60, :apex_opv2 => 0, :crop_schedule_id => 1}, :without_protection => true)
Schedule.create!({:id => 3, :event_order => 3, :month => 4, :day => 16, :year => 1, :activity_id => 3, :apex_operation => 250, :apex_crop => 2, :apex_fertilizer => 0, :apex_opv1 => 0, :apex_opv2 => 0, :crop_schedule_id => 1}, :without_protection => true)
Schedule.create!({:id => 4, :event_order => 4, :month => 5, :day => 5, :year => 1, :activity_id => 1, :apex_operation => 136, :apex_crop => 2, :apex_fertilizer => 0, :apex_opv1 => 0, :apex_opv2 => 0, :crop_schedule_id => 1}, :without_protection => true)
Schedule.create!({:id => 5, :event_order => 5, :month => 10, :day => 10, :year => 1, :activity_id => 4, :apex_operation => 626, :apex_crop => 2, :apex_fertilizer => 0, :apex_opv1 => 0, :apex_opv2 => 0, :crop_schedule_id => 1}, :without_protection => true)
Schedule.create!({:id => 6, :event_order => 6, :month => 10, :day => 11, :year => 1, :activity_id => 5, :apex_operation => 451, :apex_crop => 2, :apex_fertilizer => 0, :apex_opv1 => 0, :apex_opv2 => 0, :crop_schedule_id => 1}, :without_protection => true)
Schedule.create!({:id => 7, :event_order => 7, :month => 10, :day => 12, :year => 1, :activity_id => 3, :apex_operation => 211, :apex_crop => 2, :apex_fertilizer => 0, :apex_opv1 => 0, :apex_opv2 => 0, :crop_schedule_id => 1}, :without_protection => true)
Schedule.create!({:id => 8, :event_order => 1, :month => 5, :day => 14, :year => 1, :activity_id => 2, :apex_operation => 580, :apex_crop => 1, :apex_fertilizer => 2, :apex_opv1 => 40, :apex_opv2 => 0, :crop_schedule_id => 2}, :without_protection => true)
Schedule.create!({:id => 9, :event_order => 2, :month => 5, :day => 15, :year => 1, :activity_id => 3, :apex_operation => 250, :apex_crop => 1, :apex_fertilizer => 0, :apex_opv1 => 0, :apex_opv2 => 0, :crop_schedule_id => 2}, :without_protection => true)
Schedule.create!({:id => 10, :event_order => 3, :month => 5, :day => 15, :year => 1, :activity_id => 1, :apex_operation => 132, :apex_crop => 1, :apex_fertilizer => 0, :apex_opv1 => 0, :apex_opv2 => 0, :crop_schedule_id => 2}, :without_protection => true)
Schedule.create!({:id => 11, :event_order => 4, :month => 10, :day => 15, :year => 1, :activity_id => 4, :apex_operation => 626, :apex_crop => 1, :apex_fertilizer => 0, :apex_opv1 => 0, :apex_opv2 => 0, :crop_schedule_id => 2}, :without_protection => true)
Schedule.create!({:id => 12, :event_order => 5, :month => 10, :day => 16, :year => 1, :activity_id => 5, :apex_operation => 451, :apex_crop => 1, :apex_fertilizer => 0, :apex_opv1 => 0, :apex_opv2 => 0, :crop_schedule_id => 2}, :without_protection => true)
Schedule.create!({:id => 13, :event_order => 6, :month => 10, :day => 17, :year => 1, :activity_id => 3, :apex_operation => 211, :apex_crop => 1, :apex_fertilizer => 0, :apex_opv1 => 0, :apex_opv2 => 0, :crop_schedule_id => 2}, :without_protection => true)
Schedule.create!({:id => 14, :event_order => 1, :month => 4, :day => 14, :year => 1, :activity_id => 5, :apex_operation => 451, :apex_crop => 14, :apex_fertilizer => 0, :apex_opv1 => 0, :apex_opv2 => 0, :crop_schedule_id => 3}, :without_protection => true)
Schedule.create!({:id => 15, :event_order => 2, :month => 10, :day => 20, :year => 1, :activity_id => 1, :apex_operation => 132, :apex_crop => 14, :apex_fertilizer => 0, :apex_opv1 => 0, :apex_opv2 => 0, :crop_schedule_id => 3}, :without_protection => true)
Schedule.create!({:id => 16, :event_order => 1, :month => 4, :day => 14, :year => 1, :activity_id => 5, :apex_operation => 451, :apex_crop => 10, :apex_fertilizer => 0, :apex_opv1 => 0, :apex_opv2 => 0, :crop_schedule_id => 4}, :without_protection => true)
Schedule.create!({:id => 17, :event_order => 2, :month => 10, :day => 17, :year => 1, :activity_id => 1, :apex_operation => 132, :apex_crop => 10, :apex_fertilizer => 0, :apex_opv1 => 0, :apex_opv2 => 0, :crop_schedule_id => 4}, :without_protection => true)

Drainage.delete_all
Drainage.create!({:id => 1, :name => 'Well Drained', :wtmx => 0, :wtmn => 0, :wtbl => 0, :zqt => 0, :ztk => 0}, :without_protection => true)
Drainage.create!({:id => 2, :name => 'Poorly Drained', :wtmx => 5, :wtmn => 1, :wtbl => 2, :zqt => 2, :ztk => 1}, :without_protection => true)
Drainage.create!({:id => 3, :name => ' Somewhat Poorly Drained', :wtmx => 6, :wtmn => 1, :wtbl => 2, :zqt => 2, :ztk => 1}, :without_protection => true)

Irrigation.delete_all
Irrigation.create!({:id => 1, :name => 'Sprinkle', :status => 1, :spanish_name => 'Rociado', :code => 500}, :without_protection => true)
Irrigation.create!({:id => 2, :name => 'Furrow/Flood', :status => 1, :spanish_name => "Surco/Inundacion", :code => 502}, :without_protection => true)
Irrigation.create!({:id => 3, :name => 'Drip', :status => 1, :spanish_name => "Goteo", :code => 530}, :without_protection => true)
Irrigation.create!({:id => 7, :name => 'Furrow Diking', :status => 1, :spanish_name => "Dique en Surcos", :code => 502}, :without_protection => true)
Irrigation.create!({:id => 8, :name => 'Pads and Pipes - Tailwater Irrigation', :status => 1, :spanish_name => "Almuadiallas y Tubos - Irrigacion de Descargue", :code => 502}, :without_protection => true)
