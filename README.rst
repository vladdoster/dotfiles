Dotfiles
========

+----------------+--------------------+--------------------------------------------------------------------------------------------------------------------------+
|                    OS               |                                                Install Command                                                           |
+----------------+--------------------+--------------------------------------------------------------------------------------------------------------------------+
| Mac OS         | |mac-os build|     | ``bash <(curl -s https://raw.githubusercontent.com/vladdoster/dotfiles/arch-linux/bin/.local/bin/install.sh)``           |
+----------------+--------------------+--------------------------------------------------------------------------------------------------------------------------+
| Arch Linux     | |arch-linux build| | ``bash <(curl -s https://raw.githubusercontent.com/vladdoster/dotfiles/arch-linux/bin/.local/bin/install.sh)``           |
+----------------+--------------------+--------------------------------------------------------------------------------------------------------------------------+

Problem & Solution
------------------

+--------------------------+------------------+
|          Problem         |     Solution     |
+==========================+==================+
| manage dotfiles          | |GNU stow|       |
+--------------------------+------------------+
| {install,update} systems | [Make](Makefile) |
+--------------------------+------------------+

1. Git branches for elementary separation of concerns. Sharing the master branch
   led to obtuse workarounds for removing configs and development overhead
   deciphering configs.

1. Pull requests to keep system branches up to date. The system requires more
   diligence, but enables necessary smoke testing via CI tests (GitHub actions)
   before merging into a different system branch.

.. |arch-linux build| image:: https://github.com/vladdoster/dotfiles/workflows/Arch%20Linux/badge.svg
.. |mac-os build| image:: https://github.com/vladdoster/dotfiles/workflows/MacOS/badge.svg
