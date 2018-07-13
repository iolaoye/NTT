module AplcatParametersHelper

  def parameter_id
    [
  		[t('aplcat.nativer'), 1], [t('aplcat.introducedp'), 2]
  	]
  end

  def fuel_id
    [
      [t("Gasoline"), 1], [t("Diesel"), 2]
    ]
  end

  def listnum
    [
      [t("First Trip"), 1], [t("Second Trip"), 2], [t("Third Trip"), 3], [t("Fourth Trip"), 4]
    ]
  end
end
