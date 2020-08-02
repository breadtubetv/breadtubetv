When("I go to the Home Page") do
  visit "/"
end

Then('I should see an Upload Button') do
  expect(page).to have_link I18n.t(:upload), href: LINKS[:peertube_upload]
end

Then('I should see the Page Title and Report Link {string}') do |page_title|
  expect(page).to have_title page_title
  expect(page).to have_link I18n.t(:report_issue), href: "#{LINKS[:gitlab_issues]}?issue[title]=Report '#{ page_title }'"
end

Then('I should see the Footer') do
  within "#footer" do
    expect(page).to have_link I18n.t(:whats_breadtubetv), href: about_path
    expect(page).to have_link I18n.t(:hows_breadtubetv_work), href: process_path
    expect(page).to have_link I18n.t(:privacy_policy), href: privacy_path

    expect(page).to have_link I18n.t(:view_source_code), href: gitlab_breadtubetv_path
    expect(page).to have_link I18n.t(:developers_discord), href: discord_developers_path
    expect(page).to have_link I18n.t(:contact_us), href: LINKS[:dirkkellycom]

    expect(page).to have_link I18n.t(:youtube), href: youtube_path
    expect(page).to have_link I18n.t(:peertube), href: peertube_path
    expect(page).to have_link I18n.t(:reddit), href: reddit_path
    expect(page).to have_link I18n.t(:twitter), href: twitter_path
    expect(page).to have_link I18n.t(:facebook), href: facebook_path
    expect(page).to have_link I18n.t(:discord), href: discord_path
  end
end