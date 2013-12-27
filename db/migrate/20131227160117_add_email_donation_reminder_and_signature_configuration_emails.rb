class AddEmailDonationReminderAndSignatureConfigurationEmails < ActiveRecord::Migration
  def up
  	signature_confirmation_email = EmailType.create!(
		id: 1,
		name: 'Signature Confirmation Email',
		description: 'The signature confirmation email is delivered to a petition signer immediately after the petition is signed. The signature confirmation email is sent to all signers.',
		default_email_template: 'Signature Confirmation Email',
		default_subject: 'Your Petition Signature',
		default_state: true,
		position: 1
	)
	donation_reminder_email = EmailType.create!(
		id: 2,
		name: 'Donation Reminder Email',
		description: 'The donation reminder email is sent daily to all petition signers in the previous 24 hours.',
		default_email_template: 'Donation Reminder Email',
		default_subject: 'Can You Help?',
		default_state: false,
		position: 2
	)
  end

  def down
  	EmailType.delete_all
  end
end
