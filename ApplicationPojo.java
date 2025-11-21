package hiroaiapp.pojo;

public class ApplicationPojo {
	
	private int id; //unique ID of application number for each user
	private int userId; //unique ID of user who applies for the job
	private int jobId; //unique ID of job for which applicants are required
	private String resumePath;
	private double score;
	private String status;
	private String appliedAt;
	
	public ApplicationPojo(int id, int userId, int jobId, String resumePath, double score, String status,
			String appliedAt) {
		this.id = id;
		this.userId = userId;
		this.jobId = jobId;
		this.resumePath = resumePath;
		this.score = score;
		this.status = status;
		this.appliedAt = appliedAt;
	}

	public ApplicationPojo() {
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public int getJobId() {
		return jobId;
	}

	public void setJobId(int jobId) {
		this.jobId = jobId;
	}

	public String getResumePath() {
		return resumePath;
	}

	public void setResumePath(String resumePath) {
		this.resumePath = resumePath;
	}

	public double getScore() {
		return score;
	}

	public void setScore(double score) {
		this.score = score;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getAppliedAt() {
		return appliedAt;
	}

	public void setAppliedAt(String appliedAt) {
		this.appliedAt = appliedAt;
	}

	@Override
	public String toString() {
		return "ApplicationPojo [id=" + id + ", userId=" + userId + ", jobId=" + jobId + ", resumePath=" + resumePath
				+ ", score=" + score + ", status=" + status + ", appliedAt=" + appliedAt + "]";
	}
}
