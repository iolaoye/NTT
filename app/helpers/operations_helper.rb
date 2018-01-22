module OperationsHelper
	def listYears
		years = @project.apex_controls[0].value
		list_years = Array.new
		for i in 0..years
			list_years[i] = [i+1, i+1] 
		end
		return list_years
	end
  def listMonths
	[
		[t('months.january'), 1], [t('months.february'), 2], [t('months.march'), 3], [t('months.april'), 4], [t('months.may'), 5], [t('months.june'), 6], [t('months.july'), 7], [t('months.august'), 8], [t('months.september'), 9], [t('months.october'), 10], [t('months.november'), 11], [t('months.december'), 12]
	]
  end
  def listDays
  	[
	    [1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7], [8, 8], [9, 9], [10, 10], [11, 11], [12, 12], [13, 13], [14, 14], [15, 15], [16, 16], [17, 17], [18, 18], [19, 19], [20, 20], [21, 21], [22, 22], [23, 23], [24, 24], [25, 25], [26, 26], [27, 27], [28, 28], [29, 29], [30, 30], [31, 31]
	]
  end
end
