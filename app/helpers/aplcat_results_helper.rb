module AplcatResultsHelper

  def animals
	[
		[t('aplcat.calf'), 1], [t('aplcat.rep_heifers'), 2], [t('aplcat.fc_heifers'), 3], [t('aplcat.cow'), 4], [t('aplcat.bull'), 5]
	]
  end

  def options
	[
		[t('aplcat.agr'), 1], [t('aplcat.fir'), 2], [t('aplcat.wir'), 3], [t('aplcat.mer'), 4], [t('aplcat.nbl'), 5], [t('aplcat.ghge'), 6]
	]
  end
end
