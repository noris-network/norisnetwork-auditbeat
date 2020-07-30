Facter.add(:auditbeat_version) do
  setcode do
    if Facter::Core::Execution.which('auditbeat')
      auditbeat_version = Facter::Core::Execution.execute('auditbeat version 2>&1')
      %r{auditbeat version?\s+v?([\w\.]+)}.match(auditbeat_version)[1]
    end
  end
end
