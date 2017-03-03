#
# I'm just creating a fake object structure here to replicate what we get via
# the Xeroizer gem
#

class FakeAgedReceivablesReport < OpenStruct
  def rows
   [FakeSectionRow.new]
  end
end

class FakeSectionRow < OpenStruct
  def rows
    [FakeRow30Days.new, FakeRow90Days.new, FakeSummaryRow.new]
  end
end

class FakeRow30Days < OpenStruct
  def cells
    [
      FakeReportCell.new(DateTime.new(2015, 8, 18)),
      FakeReportCell.new("INV-001"),
      FakeReportCell.new(DateTime.new(2015, 10, 2)),
      FakeReportCell.new(15000),
      FakeReportCell.new(0),
      FakeReportCell.new(0),
      FakeReportCell.new(15000),
    ]
  end
end

class FakeRow90Days < OpenStruct
  def cells
    [
      FakeReportCell.new(DateTime.new(2015, 5, 31)),
      FakeReportCell.new("INV-001"),
      FakeReportCell.new(DateTime.new(2015, 8, 25)),
      FakeReportCell.new(20000),
      FakeReportCell.new(0),
      FakeReportCell.new(0),
      FakeReportCell.new(20000),
    ]
  end
end

class FakeSummaryRow < OpenStruct
  def cells
    [
      FakeReportCell.new("Total"),
      FakeReportCell.new(0),
      FakeReportCell.new(0),
      FakeReportCell.new(0),
      FakeReportCell.new(0),
      FakeReportCell.new(0),
      FakeReportCell.new(35000),
    ]
  end
end

class FakeReportCell < Struct.new(:value)
end
