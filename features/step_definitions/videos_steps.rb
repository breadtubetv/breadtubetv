Given("12 Videos Exist") do
  FactoryBot.create_list(:video, 12)
end

Then("I should see 12 Latest Videos") do
  within "#latest-videos" do
    expect(find('.card-row')).to have_selector('.card', count: 12)
  end
end

Then("I should see 12 Random Videos") do
  within "#random-videos" do
    expect(find('.card-row')).to have_selector('.card', count: 12)
  end
end