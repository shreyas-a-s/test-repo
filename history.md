In the [Adding New Fields](https://tripal.readthedocs.io/en/latest/user_guide/example_genomics/organisms.html#adding-new-fields) section, some fields were not added when we clicked "+ Check for new fields". Maybe they are extinct?
Q: How to add Navigation menus to all pages.
A: Structure -> Menus -> Navigation. The option should be there.
Q: How to add php-daemon  to drupal?
A: Use composer require shaneharter/php-daemon
We had created tripal_blast directory using sudo. Keep that in mind.
INFO: Anytime we install an extension module we should check for new fields (in Structure -> Tripal Content Types -> Click a content type (eg: mRNA) -> Manage fields). Extension modules often will not do this for you because they do not assume you want these new fields.
INFO: JBrowse must be unpacked and ./setup.sh run. It must be located in a directory accessible by your webserver. We recommend [drupalsite]/tools/jbrowse.
Source: https://tripal-jbrowse.readthedocs.io/en/latest/guide/install/dependencies.html
Test this out: Click on add tripal content -> genetic map -> find publication and click ass another item.
Error: AJAX HTTP error occured.
INFO: This doesn't occur in a new tripal 3 install on debian 12. Also doesn't occur in debian 11.
NEW INFO: field_group-3205283-fix_unsupported_operand_error-2.path probably fixes this.