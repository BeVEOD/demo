# -*- encoding : utf-8 -*-
module IrbjaxEngine
FileSystem = <<FILESYSTEM_EOF

# Create basic filesystem
FakeFS::FileSystem.clear

%w(bin boot dev etc home lib lost+found mnt media opt proc root sbin tmp sys usr var).each { |dir| Dir.mkdir dir }

FILESYSTEM_EOF
end

