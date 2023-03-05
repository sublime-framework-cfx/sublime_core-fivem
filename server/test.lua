function sl.test(value)
    return print(value)
end

RegisterCommand('ttz', function()
    sl.test('Ma value')
    print(sl.string.first_to_upper('yoyoyoyoyo'))
end)