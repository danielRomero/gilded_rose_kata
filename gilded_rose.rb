AGED_BRIE = 'Aged Brie'
SULFURAS_HAND_RAGNAROS = 'Sulfuras, Hand of Ragnaros'
BACKSTAGE_PASSES_TAFKAL80ETC = 'Backstage passes to a TAFKAL80ETC concert'
CONJURED = 'Conjured'

class DefaultItem
  def update(item)
    update_sell_in(item)
    update_quality(item)
    check_min_max_values(item)
    return item
  end

  def update_sell_in(item)
    item.sell_in -= 1
  end

  def update_quality(item, quality_degradate_speed=1)
    quality_degradate_speed *= 2 if item.sell_in < 0
    item.quality -= (1 * quality_degradate_speed)
  end

  def check_min_max_values item
    item.quality = 0 if item.quality < 0
    item.quality = 50 if item.quality > 50
  end

end

class AgedBrie < DefaultItem
  def update(item)
    update_sell_in(item)
    update_quality(item, -1)
    check_min_max_values(item)
    return item
  end
end

class SulfurasHandRagnaros < DefaultItem
  def update(item)
    return item
  end
end

class BackstagePassesTafkal80etc < DefaultItem
  def update_quality(item)
    if item.quality < 50 and item.quality > 0
      if item.sell_in < 10 and item.sell_in >= 5
        item.quality += 2 
      elsif item.sell_in < 5 and item.sell_in >= 0
        item.quality += 3
      elsif item.sell_in < 0
        item.quality = 0
      else
        item.quality += 1
      end
    end
  end
end

class Conjured < DefaultItem
  def update_quality(item)
    return item
  end
end

def update_quality(items)
  items.each do |item|
    case item.name
      when AGED_BRIE
        AgedBrie.new.update(item)
      when SULFURAS_HAND_RAGNAROS
        SulfurasHandRagnaros.new.update(item)
      when BACKSTAGE_PASSES_TAFKAL80ETC
        BackstagePassesTafkal80etc.new.update(item)
      when CONJURED
        Conjured.new.update(item)
      else
        DefaultItem.new.update(item)
    end
  end
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

