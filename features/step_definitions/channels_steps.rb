Then("I should see 12 Random Channels") do
  within "#random-channels" do
    expect(find('.card-row')).to have_selector('.card', count: 12)
  end
end