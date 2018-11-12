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

  def num_fmo
    [
      [t("1"), 1], [t("2"), 2], [t("3"), 3], [t("4"), 4], [t("5"), 5], [t("6"), 6], [t("7"), 7], [t("8"), 8],
      [t("9"), 9], [t("10"), 10], [t("11"), 11], [t("12"), 12], [t("13"), 13], [t("14"), 14], [t("15"), 15], [t("16"), 16],
      [t("17"), 17], [t("18"), 18], [t("19"), 19], [t("20"), 20]
    ]
  end
end
