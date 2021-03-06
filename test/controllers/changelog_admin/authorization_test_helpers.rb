module ChangelogAdmin
  module AuthorizationTestHelpers
    def test_requires_changelog_authorization(title, &block)
      test "redirects user if unauthorized - #{title}" do
        Flipper.enable(:changelog)
        user = create(:user, :onboarded, may_edit_changelog: false)

        sign_in!(user)
        instance_exec(&block)

        assert_equal 401, response.status

        Flipper.disable(:changelog)
      end

      test "allows user if authorized - #{title}" do
        Flipper.enable(:changelog)
        user = create(:user, :onboarded, may_edit_changelog: true)

        sign_in!(user)
        instance_exec(&block)

        refute_equal 401, response.status

        Flipper.disable(:changelog)
      end
    end

    def test_requires_feature_toggle(title, &block)
      test "redirects user if feature off - #{title}" do
        Flipper.disable(:changelog)
        user = create(:user, :onboarded, may_edit_changelog: true)

        sign_in!(user)
        instance_exec(&block)

        assert_equal 401, response.status
      end

      test "allows user if feature on - #{title}" do
        Flipper.enable(:changelog)
        user = create(:user, :onboarded, may_edit_changelog: true)

        sign_in!(user)
        instance_exec(&block)

        refute_equal 401, response.status

        Flipper.disable(:changelog)
      end
    end
  end
end
