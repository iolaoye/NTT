module OperationsHelper
  def listYears
    [
        ['Year 1', 1], ['Year 2', 2], ['Year 3', 3], ['Year 4', 4], ['Year 5', 5], ['Year 6', 6], ['Year 7', 7], ['Year 8', 8], ['Year 9', 9], ['Year 10', 10]
    ]
  end

  if (NTTG3::Application.config.language == "en") then
	  def listMonths
		[
			['January', 1], ['February', 2], ['March', 3], ['April', 4], ['May', 5], ['June', 6], ['July', 7], ['August', 8], ['September', 9], ['October', 10], ['November', 11], ['December', 12]
		]
	  end
  else
	  def listMonths
		[
			['Enero', 1], ['Febrero', 2], ['Marzo', 3], ['Abril', 4], ['Mayo', 5], ['Junio', 6], ['Julio', 7], ['Agosto', 8], ['Septiembre', 9], ['Octubre', 10], ['Noviembre', 11], ['Deciembre', 12]
		]
      end
  end

  def listDays
    [
        [1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7], [8, 8], [9, 9], [10, 10], [11, 11], [12, 12], [13, 13], [14, 14], [15, 15], [16, 16], [17, 17], [18, 18], [19, 19], [20, 20], [21, 21], [22, 22], [23, 23], [24, 24], [25, 25], [26, 26], [27, 27], [28, 28], [29, 29], [30, 30], [31, 31]
    ]
  end
end
