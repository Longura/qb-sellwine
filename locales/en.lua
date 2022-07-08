local Translations = {
    error = {
        negative = 'Trying to sell a negative amount?',
        no_items = 'Not enough items',
    },
    success = {
        sold = 'You have sold %{value} x %{value2} for $%{value3}',
        },
    info = {
        title = 'Wine Shop',
        open_pawn = 'Open the Wine Shop',
        sell = 'Sell Items',
        sell_pawn = 'Sell Items To The Wine Shop',
        pawn_closed = 'Wine shop is closed. Come back between %{value}:00 AM - %{value2}:00 PM',
        sell_items = 'Selling Price $%{value}',
        back = '⬅ Go Back',
        max = 'Max Amount %{value}',
        }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})