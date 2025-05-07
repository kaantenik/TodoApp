class Task < ApplicationRecord
  belongs_to :category, optional: true

  validates :title, presence: true

  enum priority: { low: 0, medium: 1, high: 2 }

  scope :completed, -> { where(completed: true) }
  scope :pending, -> { where(completed: false) }
  scope :due_today, -> { where(due_date: Date.current) }
  scope :overdue, -> { where('due_date < ? AND completed = ?', Date.current, false) }

  def complete!
    update(completed: true)
  end

  def pending?
    !completed
  end

  def formatted_due_date
    return "-" unless due_date

    # Türkçe ay isimleri
    turkish_months = {
      'January' => 'Ocak',
      'February' => 'Şubat',
      'March' => 'Mart',
      'April' => 'Nisan',
      'May' => 'Mayıs',
      'June' => 'Haziran',
      'July' => 'Temmuz',
      'August' => 'Ağustos',
      'September' => 'Eylül',
      'October' => 'Ekim',
      'November' => 'Kasım',
      'December' => 'Aralık'
    }

    formatted_date = due_date.strftime("%d %B %Y")
    turkish_months.each do |eng, tr|
      formatted_date = formatted_date.gsub(eng, tr)
    end
    formatted_date
  end

  def relative_due_date
    return "-" unless due_date

    today = Date.current
    days = (due_date - today).to_i

    case days
    when 0
      "Bugün"
    when 1
      "Yarın"
    when -1
      "Dün"
    else
      if days > 0
        "#{days} gün sonra"
      else
        "#{days.abs} gün önce"
      end
    end
  end

  def priority_color
    case priority
    when 'high'
      'danger'
    when 'medium'
      'warning'
    when 'low'
      'success'
    else
      'secondary'
    end
  end

  def turkish_priority
    case priority
    when 'low'
      'Düşük'
    when 'medium'
      'Orta'
    when 'high'
      'Yüksek'
    else
      priority
    end
  end
end
